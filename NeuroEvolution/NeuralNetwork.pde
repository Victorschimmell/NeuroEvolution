class NeuralNetwork {
  //All weights
  public float[] weights = new float[8];
  
  //All biases
  public float[] biases = new float[3];

  NeuralNetwork(float varians){
    for(int i=0; i < weights.length -1; i++){
      weights[i] = random(-varians,varians);
    }
    for(int i=0; i < biases.length -1; i++){
      biases[i] = random(-varians,varians);
    }    
  }
  
   NeuralNetwork(float[] weights, float[] biases){
    this.weights = weights;
    this.biases = biases;
  }

  float getOutput(float x1, float x2, float x3) {
    //layer1
    float o11 = weights[0]*x1+ weights[1]*x2 + weights[2]*x3 + biases[0];
    float o12 = weights[3]*x1+ weights[4]*x2 + weights[5]*x3 + biases[1];
    //layer2
    return o11*weights[6] + o12*weights[7] + biases[2];
  }
  
}
