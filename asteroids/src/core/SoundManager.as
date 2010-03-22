package core {
  
  import flash.media.SoundChannel;
  
  import mx.core.SoundAsset;
  
  /** Plays sounds and handles sound assets. Implemented as singleton. */
  public class SoundManager {
    
    /** Toggles global sound mute. */
    public static var isMute:Boolean = false;
    
    ///////////////////////////////////////////////////////
    // EFFECTS
    ///////////////////////////////////////////////////////
    
    /** A vector of all bullet sound effects. */
    private static var bulletEffects:Vector.<SoundAsset>;
    [Bindable] [Embed(source="assets/sound/bullet.mp3")] private static var bullet_1:Class;
    
    /** A vector of all launch sound effects. */
    private static var explosionEffects:Vector.<SoundAsset>;
    [Bindable] [Embed(source="assets/sound/explosion_1.mp3")] private static var explosion_1:Class;
    
    ///////////////////////////////////////////////////////
    // MUSIC
    ///////////////////////////////////////////////////////
    
    /** Channel for music. */
    private static var musicChannel:SoundChannel;
    
    private static var spacialHarvest:SoundAsset;
    [Bindable] [Embed(source="assets/sound/SpacialHarvest96.mp3")] 
    private static var spacial_harvest:Class;

    ///////////////////////////////////////////////////////
    // METHODS
    ///////////////////////////////////////////////////////
    
    /** Initialize singleton sound manager. */
    public static function initialize():void  {
      // Music.
      spacialHarvest = SoundAsset(new spacial_harvest());
 
      // Sound assets.
      bulletEffects = new Vector.<SoundAsset>();
      bulletEffects.push(SoundAsset(new bullet_1()));
      
      explosionEffects = new Vector.<SoundAsset>();
      explosionEffects.push(SoundAsset(new explosion_1()));
    }
 
    /** 
     * Plays game music. 
     * 
     * @param isLoop - If true, loops playback of game music indefinitely.
     */
    public static function playGameMusic(isLoop:Boolean):void {
      if (isMute)
        return;
      
      stopMusic();
      
      musicChannel = spacialHarvest.play(0, (isLoop ? int.MAX_VALUE : 0));
    }
    
    /** Stops playing of all music. */
    public static function stopMusic():void {
      if (isMute)
        return;      
      
      if (musicChannel != null) {
        musicChannel.stop();
      }
    }
    
    /** Plays a random bullet sound effect. */
    public static function playRandomBullet():void {
      if (isMute)
        return;      
      
      bulletEffects[int(Math.random() * bulletEffects.length)].play();
    }

    /** Plays a random explosion sound effect. */
    public static function playRandomExplosion():void {
      if (isMute)
        return;      
      
      explosionEffects[int(Math.random() * explosionEffects.length)].play();
    }
  }
}