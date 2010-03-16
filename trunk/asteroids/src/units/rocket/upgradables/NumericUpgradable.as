package units.rocket.upgradables
{
  /** An abstract upgradable numeric attribute. */ 
  public class NumericUpgradable
  {
    /** Current upgrade level. */
    protected var level:int = 1;
    
    /** Base amount of numeric value. */
    protected var baseValue:Number;
    
    /** Percentage rate of improvement per upgrade. */
    protected var upgradeRate:Number;
    
    /** Does an upgrade increase or reduce the upgradable's value? */
    protected var isRateIncrease:Boolean;

    /** Current numeric value of the upgradable. */
    public function value():Number
    {
      if (isRateIncrease)
        return baseValue * (1 + level * upgradeRate);
      else
        return baseValue * (1 - level * upgradeRate);
    }
    
    /** Price to upgrade this upgradable. Must be overriden by subclass. */
    public function costOfNextUpgrade():Number
    {
      return Number.POSITIVE_INFINITY;
    }
    
    /** 
     * If player's current money is sufficient, performs upgrade and returns
     * player bankroll less the upgrade cost. Otherwise, returns -1.
     */
    public function upgrade(currentMoney:Number):Number
    {
      var cost:Number = costOfNextUpgrade();
      
      if (cost <= currentMoney)
      {
        level += 1;
        return currentMoney - cost;
      } else
        return -1;
    }
    
  }
}