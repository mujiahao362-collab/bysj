import router from '@ohos.router';
@Entry
@Component
struct QiDong {
  @State message: string = 'Hello World'
  @State opacityValue: number = 0.3;

  onPageShow(){
    this.opacityValue=1
  }

  build() {

    Column(){

      Blank()

      Column(){

        Text('垃圾分类')
          .fontColor(Color.White)
          .fontSize(36)
          .fontWeight(FontWeight.Bold)

        Text('一键查询')
          .fontColor(Color.White)
          .fontSize(36)
          .fontWeight(FontWeight.Bold)
      }
      .alignItems(HorizontalAlign.Start)
      .opacity(this.opacityValue)
      .animation({
        duration: 1500,
        iterations: 3,
        onFinish: ()=>{
          router.replaceUrl({
            url:'pages/DengLu'})
        }
      })

      Blank()

      Blank()

      Image($r('app.media.logo'))
        .width(100)
    }
    .width('100%')
    .height('100%')
    .linearGradient({colors: [
      ['#67B1EF',0],['#FFFFFF',1]
      ]})
  }
}
