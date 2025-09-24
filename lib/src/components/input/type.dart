enum InputSize{
  large, medium, small ;
  double getScaleNum(){
    if(this==InputSize.small){
      return 0.85;
    }else if(this==InputSize.large){
      return 1.2;
    }
    return 1;
  }
}