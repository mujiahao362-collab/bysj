@Component
export default struct FenLei {
  build() {

    Column(){

      Text('尚待开发~')
    }
    .width('100%')
    .height('100%')
    .linearGradient({colors: [
      ['#67B1EF',0],['#FFFFFF',1]
    ]})
  }
}