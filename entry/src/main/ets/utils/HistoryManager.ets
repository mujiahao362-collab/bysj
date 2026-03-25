import preferences from '@ohos.data.preferences';

// 定义历史记录项接口
export interface HistoryItem {
  name: string;
  define: string;
  timestamp: number;
}

class HistoryManager {
  private preferencesKey: string = 'search_history';
  private maxHistoryCount: number = 50; // 最多保存50条记录

  // 添加历史记录
  async addHistory(name: string, define: string): Promise<void> {
    try {
      let context = getContext(this);
      let prefs = await preferences.getPreferences(context, 'garbage_history');

      // 获取现有历史记录
      let historyStr = await prefs.get(this.preferencesKey, '[]');
      let history: HistoryItem[] = JSON.parse(historyStr.toString());

      // 检查是否已存在相同记录，如果存在则删除旧的
      history = history.filter((item: HistoryItem) => item.name !== name);

      // 添加新记录到开头
      let newItem: HistoryItem = {
        name: name,
        define: define,
        timestamp: Date.now()
      };
      history.unshift(newItem);

      // 限制历史记录数量
      if (history.length > this.maxHistoryCount) {
        history = history.slice(0, this.maxHistoryCount);
      }

      // 保存
      await prefs.put(this.preferencesKey, JSON.stringify(history));
      await prefs.flush();

      console.info('历史记录已保存: ' + name);
    } catch (err) {
      console.error('保存历史记录失败: ' + JSON.stringify(err));
    }
  }

  // 获取所有历史记录
  async getHistory(): Promise<HistoryItem[]> {
    try {
      let context = getContext(this);
      let prefs = await preferences.getPreferences(context, 'garbage_history');

      let historyStr = await prefs.get(this.preferencesKey, '[]');
      let history: HistoryItem[] = JSON.parse(historyStr.toString());

      return history;
    } catch (err) {
      console.error('获取历史记录失败: ' + JSON.stringify(err));
      return [];
    }
  }

  // 清空历史记录
  async clearHistory(): Promise<void> {
    try {
      let context = getContext(this);
      let prefs = await preferences.getPreferences(context, 'garbage_history');

      await prefs.put(this.preferencesKey, '[]');
      await prefs.flush();

      console.info('历史记录已清空');
    } catch (err) {
      console.error('清空历史记录失败: ' + JSON.stringify(err));
    }
  }

  // 删除单条历史记录
  async deleteHistoryItem(name: string): Promise<void> {
    try {
      let context = getContext(this);
      let prefs = await preferences.getPreferences(context, 'garbage_history');

      let historyStr = await prefs.get(this.preferencesKey, '[]');
      let history: HistoryItem[] = JSON.parse(historyStr.toString());

      // 过滤掉指定记录
      history = history.filter((item: HistoryItem) => item.name !== name);

      await prefs.put(this.preferencesKey, JSON.stringify(history));
      await prefs.flush();

      console.info('已删除历史记录: ' + name);
    } catch (err) {
      console.error('删除历史记录失败: ' + JSON.stringify(err));
    }
  }
}

let historyManager = new HistoryManager();

export default historyManager as HistoryManager;