class ProductsValidator {

  String validateImages(List images){
    if(images.isEmpty)return 'Adicione imagens do produto!';
    else return null;
  }

  String validateTitle(String text) {
    if (text.isEmpty || text == null) return 'Preencha o título do produto!';
    return null;
  }

  String validateDescription(String text) {
    if (text.isEmpty || text == null) return 'Preencha a descrição do produto!';
    return null;
  }

  String validatePrice(String text) {
    double price = double.tryParse(text);
    if(price != null || price.isNaN){
      if(!text.contains('.') || text.split('.')[1].length != 2)
        return 'Utilize duas casas decimais';
    }else {
      return 'Preço inválido';
    }
    return null;
  }


}
