package units.rocket.upgradables
{
  public class HyperspaceUpgrade extends NumericUpgradable
  {
    public function HyperspaceUpgrade()
    {
      super();
      
      baseValue = 0.4;
      upgradeRate = 0.15;
      
      isRateIncrease = false;
    }
    
    override public function value():Number
    {
      return baseValue * (1 - level * upgradeRate);
    }
    
    override public function costOfNextUpgrade():Number
    {
      return (level * level) * 100 + 500;
    }
  }
}