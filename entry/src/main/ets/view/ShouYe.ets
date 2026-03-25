import taskmodel from '../task/taskmodel';
import historyManager from '../utils/HistoryManager';
import promptAction from '@ohos.promptAction';

interface TaskRecord {
  ID: number;
  NAME: string;
  DEFINE: string;
}

@Component
export default struct ShouYe {
  @State define: string = '';
  @State name: string = '';
  @State changeValue: string = '';
  @State resultTable: TaskRecord[] = [];
  @State isSearching: boolean = false;
  @State showResult: boolean = false;
  @State lastSearchTime: number = 0;
  controller: SearchController = new SearchController();

  build() {
    Column() {
      Row() {
        Search({
          value: this.changeValue,
          placeholder: '请输入垃圾名称',
          controller: this.controller
        })
          .onChange((value: string) => {
            this.changeValue = value;
          })
          .onSubmit((value: string) => {
            this.performSearch(value);
          })
          .searchButton('搜索')
          .width('100%');
      }
      .width('90%')
      .margin({ bottom: 20, top: 20 });

      Text('搜索结果')
        .fontSize(18)
        .margin({ bottom: 10, top: 10 })
        .fontWeight(FontWeight.Bold);

      // 搜索中状态
      if (this.isSearching) {
        Row() {
          LoadingProgress()
            .width(30)
            .height(30)
            .color('#67B1EF');
          Text('  搜索中...')
            .fontSize(16)
            .fontColor('#999999');
        }
        .margin({ top: 10 });
      }
      // 显示表格结果
      else if (this.showResult && this.resultTable.length > 0) {
        this.buildResultTable();
      }
      // 空状态或未找到结果
      else if (this.define !== '') {
        Column() {
          Image($r('app.media.icon'))
            .width(60)
            .height(60)
            .opacity(0.3);
          Text(this.define)
            .fontSize(16)
            .fontColor('#FF5722')
            .margin({ top: 10 });
        }
        .margin({ top: 20 })
        .padding(20)
        .backgroundColor('#FFE5E5')
        .borderRadius(8);
      }

      // 轮播图
      Swiper() {
        Image($r('app.media.1'))
        Image($r('app.media.2'))
        Image($r('app.media.3'))
        Image($r('app.media.4'))
        Image($r('app.media.5'))
        Image($r('app.media.6'))
        Image($r('app.media.7'))
        Image($r('app.media.8'))
        Image($r('app.media.9'))
        Image($r('app.media.10'))
        Image($r('app.media.11'))
        Image($r('app.media.12'))
        Image($r('app.media.13'))
        Image($r('app.media.14'))
        Image($r('app.media.15'))
        Image($r('app.media.16'))
        Image($r('app.media.17'))
        Image($r('app.media.18'))
      }
      .width('100%')
      .height('35%')
      .index(6)
      .indicator(true)
      .vertical(false)
      .loop(true)
      .autoPlay(true)
      .interval(2000)
      .margin({ top: 20, bottom: 20 });

      Text('精确搜索请在上方输入垃圾名称')
        .fontSize(14)
        .margin({ bottom: 10 })
        .fontWeight(FontWeight.Bolder);

      Text('图像识别请在更多中使用')
        .fontSize(14)
        .margin({ bottom: 20 })
        .fontWeight(FontWeight.Bolder);
    }
    .width('100%')
    .height('100%')
    .linearGradient({
      colors: [
        ['#67B1EF', 0],
        ['#FFFFFF', 1]
      ]
    });
  }

  // 独立的表格构建方法
  @Builder
  buildResultTable() {
    Column() {
      // 表格表头
      Row() {
        Text('垃圾名称')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .width('50%')
          .textAlign(TextAlign.Center)
          .fontColor('#FFFFFF');

        Text('分类')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .width('50%')
          .textAlign(TextAlign.Center)
          .fontColor('#FFFFFF');
      }
      .backgroundColor('#67B1EF')
      .padding({ top: 12, bottom: 12 })
      .width('100%')
      .borderRadius({ topLeft: 8, topRight: 8 });

      // 表格内容
      ForEach(this.resultTable, (item: TaskRecord) => {
        Row() {
          Text(item.NAME)
            .fontSize(18)
            .width('50%')
            .textAlign(TextAlign.Center)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333');

          Text(item.DEFINE)
            .fontSize(18)
            .width('50%')
            .textAlign(TextAlign.Center)
            .fontColor(this.getColorByCategory(item.DEFINE))
            .fontWeight(FontWeight.Bold);
        }
        .padding({ top: 15, bottom: 15 })
        .backgroundColor('#FFFFFF')
        .border({
          width: { left: 1, right: 1, bottom: 1 },
          color: '#E0E0E0'
        })
        .width('100%');
      }, (item: TaskRecord) => {
        return item.ID.toString() + '_' + this.lastSearchTime.toString();
      });
    }
    .width('90%')
    .shadow({
      radius: 10,
      offsetY: 3,
      color: 'rgba(0, 0, 0, 0.15)'
    })
    .borderRadius(8)
    .margin({ top: 10 });
  }

  // 根据垃圾分类返回对应颜色
  getColorByCategory(category: string): ResourceColor {
    if (category.includes('可回收')) {
      return '#2196F3';
    } else if (category.includes('有害')) {
      return '#F44336';
    } else if (category.includes('湿') || category.includes('厨余')) {
      return '#4CAF50';
    } else if (category.includes('干') || category.includes('其他')) {
      return '#9E9E9E';
    }
    return '#333333';
  }

  // 执行搜索
  async performSearch(value: string): Promise<void> {
    if (!value || value.trim() === '') {
      promptAction.showToast({ message: '请输入垃圾名称', duration: 2000 });
      return;
    }

    let searchKeyword = value.trim();
    console.info('==========================================');
    console.info('开始搜索: ' + searchKeyword);
    console.info('==========================================');

    // 清空所有状态
    this.showResult = false;
    this.resultTable = [];
    this.define = '';
    this.name = '';
    this.isSearching = true;

    try {
      let data = await taskmodel.getData(searchKeyword);

      console.info('查询返回数据: ' + JSON.stringify(data));

      if (data && data.NAME && data.DEFINE) {
        console.info('垃圾名称: ' + data.NAME);
        console.info('垃圾分类: ' + data.DEFINE);

        // 更新状态变量
        this.name = data.NAME;
        this.define = data.DEFINE;

        // 保存到历史记录
        await historyManager.addHistory(data.NAME, data.DEFINE);

        // 创建新的结果对象
        let newResult: TaskRecord = {
          ID: data.ID,
          NAME: data.NAME,
          DEFINE: data.DEFINE
        };

        // 更新时间戳
        this.lastSearchTime = Date.now();

        // 更新表格数据
        this.resultTable = [newResult];

        // 显示结果
        this.showResult = true;

        console.info('表格数据已更新:');
        console.info('  ID: ' + this.resultTable[0].ID);
        console.info('  名称: ' + this.resultTable[0].NAME);
        console.info('  分类: ' + this.resultTable[0].DEFINE);
        console.info('  时间戳: ' + this.lastSearchTime);

        promptAction.showToast({
          message: data.NAME + ' 属于 ' + data.DEFINE,
          duration: 2000
        });
      } else {
        console.warn('未找到结果: ' + searchKeyword);
        this.showResult = false;
        this.resultTable = [];
        this.define = '未找到 "' + searchKeyword + '" 的相关信息';
        promptAction.showToast({ message: '未找到相关垃圾信息', duration: 2000 });
      }
    } catch (err) {
      let error = err as Error;
      console.error('查询失败: ' + error.message);
      console.error('错误详情: ' + JSON.stringify(err));
      this.showResult = false;
      this.resultTable = [];
      this.define = '查询失败：' + error.message;
      promptAction.showToast({ message: '查询失败，请重试', duration: 2000 });
    } finally {
      this.isSearching = false;
      console.info('==========================================');
    }
  }
}