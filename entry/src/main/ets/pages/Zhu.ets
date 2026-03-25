import FenLei from '../view/FenLei'
import GengDuo from '../view/GengDuo'
import ShouYe from '../view/ShouYe'
import WoDe from '../view/WoDe'
import taskmodel from '../task/taskmodel'

@Entry
@Component
struct ZhuJieMian {
  @State currentIndex: number = 0
  private tabsController: TabsController = new TabsController()

  @Builder
  TabBuilder(title: string, image: Resource, selectImage: Resource, tag: number) {
    Column() {
      Image(this.currentIndex == tag ? selectImage : image)
        .size({ width: 24, height: 24 })
        .objectFit(ImageFit.Contain)
        .interpolation(ImageInterpolation.High)

      Text(title)
        .fontSize(14)
        .fontColor(this.currentIndex == tag ? '#67B1EF' : '#C0C0C0')
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .border({
      width: { top: 1 },
      color: '#E0E0E0'
    })
    .onClick(() => {
      this.currentIndex = tag
      this.tabsController.changeIndex(this.currentIndex)
    })
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {

        // 第一个 Tab（左边）：首页 - 显示 ShouYe 图标 - 显示 GengDuo 页面
        TabContent() {
          GengDuo()
        }
        .tabBar(this.TabBuilder('首页', $r('app.media.ShouYe2'), $r('app.media.ShouYe1'), 0))

        // 第二个 Tab（中间）：更多 - 显示 GengDuo 图标 - 显示 ShouYe 页面
        TabContent() {
          ShouYe()
        }
        .tabBar(this.TabBuilder('更多', $r('app.media.GengDuo2'), $r('app.media.GengDuo1'), 1))

        // 第三个 Tab（右边）：我的 - 显示 WoDe 图标 - 显示 WoDe 页面
        TabContent() {
          WoDe()
        }
        .tabBar(this.TabBuilder('我的', $r('app.media.WoDe2'), $r('app.media.WoDe1'), 2))
      }
      .height('100%')
      .width('100%')
      .barHeight(50)
      .backgroundColor('#FFFFFF')
      .onChange((index: number) => {
        this.currentIndex = index
      })
    }
    .width('100%')
    .height('100%')
  }
}