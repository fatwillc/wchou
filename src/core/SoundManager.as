package core {
  
  import __AS3__.vec.Vector;
  
  import flash.media.SoundChannel;
  
  import mx.core.SoundAsset;
  import mx.effects.SoundEffect;
  
  /** 
   * Plays sounds and handles sound assets. 
   * Implemented as a singleton.
   */
  public class SoundManager {
    
    ///////////////////////////////////////////////////////
    // EFFECTS
    ///////////////////////////////////////////////////////
    
    /** Channel for infect effects. */
    private static var infectChannel:SoundChannel;
    /** A vector of all infect sound effects. */
    private static var infects:Vector.<SoundAsset>;
    
    [Bindable] [Embed(source="assets/sound/infect_1.mp3")] private static var infect_1:Class;
    
    /** Channel for launch effects. */
    private static var launchChannel:SoundChannel;
    /** A vector of all launch sound effects. */
    private static var launchs:Vector.<SoundAsset>;
    
    [Bindable] [Embed(source="assets/sound/launch_1.mp3")] private static var launch_1:Class;
    [Bindable] [Embed(source="assets/sound/launch_2.mp3")] private static var launch_2:Class;
    
    ///////////////////////////////////////////////////////
    // MUSIC
    ///////////////////////////////////////////////////////
    
    /** Channel for music. */
    private static var musicChannel:SoundChannel;
    
    private static var redViolin:SoundAsset;
    [Bindable] [Embed(source="assets/sound/RedViolin.mp3")] private static var red_violin:Class;

    ///////////////////////////////////////////////////////
    // METHODS
    ///////////////////////////////////////////////////////
    
    /** Create a new sound manager. */
    public static function initialize():void  {
      // Music.
      redViolin = SoundAsset(new red_violin());
 
      // Sound assets.
      infects = new Vector.<SoundAsset>();
      infects.push(SoundAsset(new infect_1()));
      
      launchs = new Vector.<SoundAsset>();
      launchs.push(SoundAsset(new launch_1()));
      launchs.push(SoundAsset(new launch_2()));
    }
    
    /** Plays game music. */
    public static function playGameMusic():void {
      stopMusic();
      
      musicChannel = redViolin.play();
    }
    
    /** Stops playing of all music. */
    public static function stopMusic():void {
      if (musicChannel != null) {
        musicChannel.stop();
      }
    }
    
    /** Plays a random infect sound effect. */
    public static function playRandomInfect():void {
      if (infectChannel != null) {
        infectChannel.stop();
      }
      
      infectChannel = infects[int(Math.random() * infects.length)].play();
    }
    
    /** Plays a random launch sound effect. */
    public static function playRandomLaunch():void {
      if (launchChannel != null) {
        launchChannel.stop();
      }
      
      launchChannel = launchs[int(Math.random() * launchs.length)].play();
    }
  }
}