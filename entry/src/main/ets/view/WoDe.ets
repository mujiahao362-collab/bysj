import router from '@ohos.router';

// 定义菜单项接口
interface WodeMenuItem {
  icon: Resource;
  text: string;
  url: string;
}

@Component
export default struct WoDe {
  @State wodelist: WodeMenuItem[] = [{
    icon: $r("app.media.lishi"),
    text: '历史记录',
    url: 'pages/LiShi'
  }, {
    icon: $r("app.media.shoucang"),
    text: '收藏',
    url: ''
  }, {
    icon: $r("app.media.shezhi"),
    text: '设置',
    url: ''
  }];

  build() {
    Column() {
      Scroll() {
        Column() {
          Column() {
            Row() {
              Image($r("app.media.DengLuJieMian"))
                .width(80)
                .height(80)
                .borderRadius(50);

              Text('我的')
                .fontSize(52)
                .size({ width: 180, height: 200 })
                .fontWeight(FontWeight.Bolder)
                .padding({
                  top: 10,
                  left: 30
                });
            }
            .padding({
              top: 40,
              left: 20
            })
            .width('100%');

            Column() {
              ForEach(this.wodelist, (item: WodeMenuItem) => {
                wodeitem({
                  text: item.text,
                  icon: item.icon,
                  url: item.url
                });
              });
            }
          }
        }
        .height('100%')
        .width('100%');
      }
      .scrollBarWidth(0);
    }
    .height('100%')
    .linearGradient({
      colors: [
        ['#67B1EF', 0],
        ['#FFFFFF', 1]
      ]
    });
  }
}

@Component
struct wodeitem {
  icon: Resource = $r("app.media.icon");
  text: string = "";
  url: string = "";

  build() {
    Row() {
      Image(this.icon)
        .height(50)
        .width(50);

      Text(this.text)
        .margin({
          left: 20
        })
        .fontSize(26)
        .size({ width: 180, height: 90 });

      Image($r("app.media.You"))
        .height(50)
        .width(50);
    }
    .width('90%')
    .height(100)
    .justifyContent(FlexAlign.SpaceBetween)
    .border({
      color: 'black',
      width: 0.2,
      radius: 20
    })
    .padding({
      left: 15,
      right: 15,
    })
    .shadow({
      radius: 15,
      offsetY: 5,
      offsetX: 5,
      color: '#67B1EF'
    })
    .margin({
      bottom: 30
    })
    .onClick(() => {
      if (this.url) {
        router.pushUrl({ url: this.url });
      }
    });
  }
}