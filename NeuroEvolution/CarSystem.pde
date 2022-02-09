class Population {
  //CarSystem - 
 float mutationsrate;
 
  ArrayList<CarController> population  = new ArrayList<CarController>();
  ArrayList<CarController> matingpool;
  int generations;             // Number of generations

  Population(int populationSize, float mutationrate) {
    this.mutationsrate = mutationrate;
    
    for (int i=0; i<populationSize; i++) { 
      CarController controller = new CarController();
      population.add(controller);
    }
    
    matingpool = new ArrayList<CarController>();
    
    
  }

  void updateAndDisplay() {
    //1.) Opdaterer sensorer og bilpositioner
    for (CarController controller : population) {
      controller.update();
    }
    
    if(showAll){
    //2.) Tegner tilsidst - så sensorer kun ser banen og ikke andre biler!
    for (CarController controller : population) {
      controller.display();
    } 
    } else{
    
    population.get(recordholder).display();
    }
    
  }
  
    void fitness() {
    for (int i = 0; i < population.size(); i++) {
      population.get(i).getFitness();
    }
    println("R: " + getMaxFitness() + " : RH : " + recordholder);
  }
  
   void selection() {
    // Clear the ArrayList
    matingpool.clear();

    // Calculate total fitness of whole population
    float maxFitness = getMaxFitness();
    

    // Calculate fitness for each member of the population (scaled to value between 0 and 1)
    // Based on fitness, each member will get added to the mating pool a certain number of times
    // A higher fitness = more entries to mating pool = more likely to be picked as a parent
    // A lower fitness = fewer entries to mating pool = less likely to be picked as a parent
    for (int i = 0; i < population.size(); i++) {
      float fitnessNormal = map(population.get(i).getFitness(),0,maxFitness,0,1);
      int n = (int) (fitnessNormal * 100);  // Arbitrary multiplier
      for (int j = 0; j < n; j++) {
        matingpool.add(population.get(i));
      }
    }
  }
    // Making the next generation
  void reproduction() {
    // Refill the population with children from the mating pool
    for (int i = 0; i < population.size(); i++) {
      // Sping the wheel of fortune to pick two parents
      int m = int(random(matingpool.size()));
      int d = int(random(matingpool.size()));
      // Pick two parents
      CarController mom = matingpool.get(m);
      CarController dad = matingpool.get(d);
      // Get their genes
      float[] momgenes1 = mom.getDNA1();
      float[] momgenes2 = mom.getDNA2();
      float[] dadgenes1 = dad.getDNA1();
      float[] dadgenes2 = dad.getDNA2();
      // Mate their genes
      float[] childDNA1 = crossover(momgenes1, dadgenes1);
      float[] childDNA2 = crossover(momgenes2, dadgenes2);
      // Mutate their genes
      mutate(mutationrate, childDNA1);
      // Fill the new population with the new child
      population.set(i, new CarController(childDNA1, childDNA2));
    }
    generations++;
    println("Generation: " + generations);
    
  }
  
    int getGenerations() {
    return generations;
  }
  
  float getMaxFitness() {
    float record = 0;
    for (int i = 0; i < population.size(); i++) {
       if(population.get(i).getFitness() > record) {
         record = population.get(i).getFitness();
         recordholder = i;
       }
    }
    
    return record;
  }
  
    float[] crossover(float[] partner1, float[] partner2) {
    float[] child = new float[partner1.length];
    // Pick a midpoint
    int crossoverint = int(random(partner1.length));
    // Take "half" from one and "half" from the other
    for (int i = 0; i < child.length; i++) {
      if (i > crossoverint) child[i] = partner1[i];
      else               child[i] = partner2[i];
    }    
    float[] newgenes = child;
    return newgenes;
  }
  void mutate(float m, float[] child) {
    for (int i = 0; i < child.length; i++) {
      if (random(1) < m) {
        child[i] = random(-varians,varians);
      }
    }
  }
  
  
  
  
}
