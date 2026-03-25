import router from '@ohos.router';

@Component
export default struct GengDuo {

  private option1: router.RouterOptions = {
    url: 'pages/WenJuan'
  }

  private option2: router.RouterOptions = {
    url: 'pages/Wy'
  }

  build() {
    Column() {
      // 标题区域
      Column() {
        Text('垃圾分类助手')
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .margin({ bottom: 8 });

        Text('精准分类，守护环境')
          .fontSize(14)
          .fontColor('rgba(255, 255, 255, 0.8)')
      }
      .width('90%')
      .padding({ top: 30, bottom: 30 })
      .margin({ bottom: 40 });

      // 功能卡片区域
      Column({ space: 20 }) {
        // 问卷卡片
        this.buildFunctionCard(
          '垃圾分类小问卷',
          '了解你的垃圾分类知识水平',
          '📋',
          '#FF6B6B',
          this.option1
        );

        // 图像识别卡片
        this.buildFunctionCard(
          '图像识别',
          '拍照识别垃圾，智能分类',
          '📸',
          '#4ECDC4',
          this.option2
        );
      }
      .width('90%')
      .margin({ bottom: 40 });

      // 提示信息
      Column() {
        Row() {
          Image($r('app.media.icon'))
            .width(20)
            .height(20)
            .fillColor('#67B1EF')
            .margin({ right: 8 });

          Text('点击上方任意功能开始体验')
            .fontSize(13)
            .fontColor('#67B1EF')
        }
        .padding(12)
        .backgroundColor('rgba(103, 177, 239, 0.1)')
        .borderRadius(8)
        .width('100%');
      }
      .width('90%')
      .margin({ bottom: 30 });

      // 使用 Blank() 替代 Spacer()
      Blank()
        .layoutWeight(1);

      // 底部装饰
      Column() {
        Text('让我们一起守护美丽地球')
          .fontSize(12)
          .fontColor('#999999')
      }
      .padding({ bottom: 20 });
    }
    .width('100%')
    .height('100%')
    .padding({ left: 0, right: 0 })
    .linearGradient({
      colors: [
        ['#67B1EF', 0],
        ['#FFFFFF', 1]
      ]
    });
  }

  // 构建功能卡片
  @Builder
  buildFunctionCard(title: string, subtitle: string, emoji: string, cardColor: string, option: router.RouterOptions) {
    Column() {
      Row() {
        Column({ space: 8 }) {
          Text(title)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333');

          Text(subtitle)
            .fontSize(13)
            .fontColor('#666666')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis });
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start);

        Text(emoji)
          .fontSize(40)
          .margin({ left: 12 });
      }
      .width('100%')
      .padding({ top: 20, bottom: 20, left: 16, right: 16 })
      .alignItems(VerticalAlign.Center);

      // 点击区域指示
      Row() {
        Text('点击进入')
          .fontSize(12)
          .fontColor(cardColor)
          .fontWeight(FontWeight.Medium);

        Image($r('app.media.icon'))
          .width(14)
          .height(14)
          .fillColor(cardColor)
          .margin({ left: 4 });
      }
      .padding({ top: 12, bottom: 12, left: 16, right: 16 })
      .width('100%')
      .backgroundColor('rgba(0, 0, 0, 0.02)');
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({
      radius: 8,
      color: 'rgba(0, 0, 0, 0.1)',
      offsetY: 2
    })
    .onClick(() => {
      router.pushUrl(option);
    });
  }
}