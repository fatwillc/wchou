package units.rocket.upgradables
{
  public class AccelerationUpgrade extends NumericUpgradable
  {
    public function AccelerationUpgrade()
    {
      super();
      
      baseValue = 4;
      upgradeRate = 0.2;
      
      isRateIncrease = true;
    }
    
    override public function costOfNextUpgrade():Number
    {
      return (level * level) * 100 + 500;
    }
  }
}