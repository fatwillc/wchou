package utils 
{
  import mx.controls.Label;
  import mx.formatters.NumberFormatter;
  
  /** 
   * A simple FPS display. 
   */
  public class FPS 
  {
    /** 
     * Label used to display FPS. 
     */
    private var label:Label;
    
    /** 
     * Number of frames per FPS display update. 
     */
    private var displayInterval:int;
    
    /** 
     * Aggregate framerate since the last display. 
     */
    private var aggregateFramerate:Number = 0;
    
    /** 
     * Number of times framerate was aggregated into aggregateFramerate. 
     */
    private var numberAggregate:int = 0;
    
    /** 
     * Formats FPS numeral. 
     */
    private var formatter:NumberFormatter;
    
    public function FPS(label:Label, displayInterval:int = 5) 
    {
      this.label = label;
      this.displayInterval = displayInterval;
      
      formatter = new NumberFormatter();
      formatter.precision = 2;
    }
    
    public function update(dT:Number):void 
    {
      aggregateFramerate += (1 / dT);
      numberAggregate    += 1;
      
      if (numberAggregate > displayInterval) {
        label.text = "FPS: " + formatter.format(aggregateFramerate / numberAggregate).toString();
        
        aggregateFramerate = numberAggregate = 0;
      }
    }
  }
}