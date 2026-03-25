import router from '@ohos.router';
import historyManager, { HistoryItem } from '../utils/HistoryManager';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct LiShi {
  @State historyList: HistoryItem[] = [];

  async aboutToAppear(): Promise<void> {
    await this.loadHistory();
  }

  // 加载历史记录
  async loadHistory(): Promise<void> {
    this.historyList = await historyManager.getHistory();
  }

  // 清空所有历史
  async clearAllHistory(): Promise<void> {
    await historyManager.clearHistory();
    this.historyList = [];
    promptAction.showToast({ message: '已清空历史记录' });
  }

  // 删除单条记录
  async deleteItem(name: string): Promise<void> {
    await historyManager.deleteHistoryItem(name);
    await this.loadHistory();
    promptAction.showToast({ message: '已删除' });
  }

  // 格式化时间
  formatTime(timestamp: number): string {
    let date = new Date(timestamp);
    let month = (date.getMonth() + 1).toString().padStart(2, '0');
    let day = date.getDate().toString().padStart(2, '0');
    let hours = date.getHours().toString().padStart(2, '0');
    let minutes = date.getMinutes().toString().padStart(2, '0');
    return `${month}-${day} ${hours}:${minutes}`;
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Image($r('app.media.icon'))
          .width(24)
          .height(24)
          .onClick(() => {
            router.back();
          });

        Text('搜索历史')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center);

        Text('清空')
          .fontSize(16)
          .fontColor('#67B1EF')
          .onClick(() => {
            this.clearAllHistory();
          });
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF');

      if (this.historyList.length === 0) {
        // 空状态
        Column() {
          Image($r('app.media.icon'))
            .width(100)
            .height(100)
            .opacity(0.3);
          Text('暂无搜索历史')
            .fontSize(16)
            .fontColor('#999999')
            .margin({ top: 20 });
        }
        .width('100%')
        .height('80%')
        .justifyContent(FlexAlign.Center);
      } else {
        // 历史记录列表
        Scroll() {
          Column() {
            ForEach(this.historyList, (item: HistoryItem, index: number) => {
              Row() {
                Column() {
                  Text(item.name)
                    .fontSize(18)
                    .fontWeight(FontWeight.Medium)
                    .margin({ bottom: 5 });

                  Text(item.define)
                    .fontSize(14)
                    .fontColor('#67B1EF')
                    .margin({ bottom: 5 });

                  Text(this.formatTime(item.timestamp))
                    .fontSize(12)
                    .fontColor('#999999');
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1);

                Image($r('app.media.icon'))
                  .width(20)
                  .height(20)
                  .onClick(() => {
                    this.deleteItem(item.name);
                  });
              }
              .width('90%')
              .padding(15)
              .margin({ top: 10 })
              .backgroundColor('#FFFFFF')
              .borderRadius(10)
              .shadow({
                radius: 5,
                offsetY: 2,
                color: 'rgba(0, 0, 0, 0.1)'
              });
            }, (item: HistoryItem, index: number) => index.toString());
          }
          .width('100%')
          .padding({ top: 10, bottom: 10 });
        }
        .width('100%')
        .layoutWeight(1)
        .scrollBarWidth(0);
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5');
  }
}