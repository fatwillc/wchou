package units.rocket.upgradables
{
  public class ReloadUpgrade extends NumericUpgradable
  {
    public function ReloadUpgrade()
    {
      super();
      
      baseValue = 0.5;
      upgradeRate = 0.07;
      
      isRateIncrease = false;
    }
    
    override public function costOfNextUpgrade():Number
    {
      return (level * level) * 100 + 500;
    }
  }
}