class ChatMessages{
  int bootMessageIndex = 0;
  List<String> bootMessages = [
    "Fala parceiro, pode de me chamar de Rubinho",
    "eu to aqui pra te ajuda, ta se sentindo como amigo?",
    "Mas credo, ta nervoso?",
    "vou te da umas dicas pra se acalmar parceiro",
    "Respira fundo conta até 3 depois solta o ar e conta até seis",
    "da uma pausa em cada vez que for repeti",
    "ta melhor parceiro?",
    "opa, então até a próxima e boa viajada!!!",
    "entra em contato com um médico aqui parceiro",
    "(telefone de contato com estrada pela saúde e cvv)",
    "opa, então até a próxima e boa viajada!!!",
    "vou te ajuda a se alonga parceiro",
    "Ainda sentado, tu puxa os joelhos, segure e deixa bem perto do peito por 30 a 60 segundos. Desse modo, você vai ta alongando a coluna",
    'Agora puxa a cabeça para o lado esquerdo com a mão esquerda até sentir uma leve pressão na lateral do pescoço, faz o mesmo com o outro lado. Mantem uns 15 segundos em cada lado\nisso te ajuda a reduzir a tensão acumulada no pescoço e aumentar a circulação do sangue.'
    "não te apressa que tem mais, vamos dirigir 100%",
    "Faça movimentos circulares com os ombros para frente e para trás sempre lentamente, 10 vezes pra frente e 10 pra tráz Assim, tu da um alívio na região dos ombros e pescoço e também melhora a dor constante ou crônicas.",
    "Entrelace os dedos e estenda os braços para frente com a palma da mão para fora e curve lentamente as costas, permanecendo por 10 a 15 segundos nessa posição. Dessa forma, você sentirá alongar as costas e também os braços, diminuindo dores nas costas e contribuindo para manter uma postura correta.",
    "Pressione o cotovelo direito com os braços estendidos em direção ao corpo (em cima do peito) e mantenha a cabeça em cima do ombro direito, faça o mesmo com o lado esquerdo. Permaneça assim por 15 segundos de cada lado. Dessa forma, você estará alongando os braços e os ombros, aliviando a tensão e melhorando a flexibilidade.",
    "juro que vai termina logo amigo, só quero o teu melhor",
    "Coloque os braços para trás do corpo, cruze os dedos e pressione o tórax levemente para frente, sentindo alongar o peito, permaneça nessa posição por 15 segundos. Dessa forma, você estará contribuindo por uma melhor postura, respiração correta e diminuição da tensão sobre os ombros, prevenindo contra a postura incorreta e o peitoral retraído.",
    "Coloque as mãos entrelaçadas atrás da cabeça e pressione para baixo, encostando o queixo no peito, permaneça por 15 segundos. Assim, você estará alongando as vértebras cervicais e proporcionará o aumento da flexibilidade do pescoço, prevenindo dores e rigidez nessa região.",
    "Entrelace os dedos e estenda os braços para frente com a palma da mão para fora e curve lentamente as costas, permanecendo por 10 a 15 segundos nessa posição. Dessa forma, você sentirá alongar as costas e também os braços, diminuindo dores nas costas e contribuindo para manter uma postura correta.",
    "pronto, agora só pisa fundo e boa viajada parceiro"
  ];
  List<String> bootOpcoes = [
    "To nervoso, só incomodação na estrada",
    "100%",
    "ainda não!",
    "to muito tempo parado, que dor nas costas"
  ];

  bool terminei(){
    if(bootMessageIndex==bootMessages.length-1)
      return true;
    else
      return false;
  }

  List<String> getProximasMensagens(){
    List<String> ret = new List<String>();
    if(this.bootMessageIndex<=1){
      ret.add(this.bootMessages[0]);
      ret.add(this.bootMessages[1]);
      this.bootMessageIndex = 1;
    }
    else if(this.bootMessageIndex<=6){
      ret.add(this.bootMessages[2]);
      ret.add(this.bootMessages[3]);
      ret.add(this.bootMessages[4]);
      ret.add(this.bootMessages[5]);
      ret.add(this.bootMessages[6]);
      this.bootMessageIndex = 6;
    }
    else if(this.bootMessageIndex==7){
      ret.add(this.bootMessages[7]);
      this.bootMessageIndex = 7;
    }
    else if(this.bootMessageIndex<=10){
      ret.add(this.bootMessages[8]);
      ret.add(this.bootMessages[9]);
      ret.add(this.bootMessages[10]);
      this.bootMessageIndex = 10;
    }
    else{
      for(int i=this.bootMessageIndex;i<this.bootMessages.length;i++)
        ret.add(this.bootMessages[i]);
      this.bootMessageIndex = this.bootMessages.length-1;
    }
    return ret;
  }

  List<String> getProximasOpcoes(){
    List<String> ret = new List<String>();
    if(this.bootMessageIndex==1){
      ret.add(this.bootOpcoes[0]);
      ret.add(this.bootOpcoes[3]);
    }
    else if(this.bootMessageIndex==6){
      ret.add(this.bootOpcoes[1]);
      ret.add(this.bootOpcoes[2]);
    }
    else{
      print('aconteceu algo de errado');
    }
    return ret;
  }

  setOpcao(String opcao){
    int i=0;
    while(i<this.bootOpcoes.length){
      if(opcao==this.bootOpcoes[i])
        break;
      i++;
    }
    print("AQUI "+i.toString());
    if(i==0){
      this.bootMessageIndex = 2;
    }
    else if(i==1){
      this.bootMessageIndex = 7;
    }
    else if(i==2){
      this.bootMessageIndex = 8;
    }
    else if(i==3){
      this.bootMessageIndex = 11;
    }
  }
}