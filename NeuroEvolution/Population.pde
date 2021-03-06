class Population {
  //CarSystem - 
 float mutationsrate;
 
  ArrayList<Vehicle> population  = new ArrayList<Vehicle>();
  ArrayList<Vehicle> matingpool;
  int generations;             // Number of generations

  Population(int populationSize, float mutationrate) {
    this.mutationsrate = mutationrate;
    
    for (int i=0; i<populationSize; i++) { 
      Vehicle controller = new Vehicle();
      population.add(controller);
    }
    
    matingpool = new ArrayList<Vehicle>();
    
    
  }

  void updateAndDisplay() {
    //1.) Opdaterer sensorer og bilpositioner
    for (Vehicle controller : population) {
      controller.update();
    }
    
    if(showAll){
    //2.) Tegner tilsidst - så sensorer kun ser banen og ikke andre biler!
    for (Vehicle controller : population) {
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
    
    println("matingpool : " + matingpool.size());
  }
    // Making the next generation
  void reproduction() {
    population.clear();
    // Refill the population with children from the mating pool
    for (int i = 0; i < populationSize; i++) {
      // Sping the wheel of fortune to pick two parents
      int m = int(random(matingpool.size()));
      int d = int(random(matingpool.size()));
      // Pick two parents
      Vehicle mom = matingpool.get(m);
      Vehicle dad = matingpool.get(d);
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
      population.add( new Vehicle(childDNA1, childDNA2));
    }
    generations++;
    println("Generation: " + generations);
    println(population.size());
    
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
