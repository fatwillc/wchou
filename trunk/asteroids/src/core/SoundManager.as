package core {
  
  import flash.media.SoundChannel;
  
  import mx.core.SoundAsset;
  
  /** Plays sounds and handles sound assets. Implemented as singleton. */
  public class SoundManager {
    
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
    
    private static var newFriendly:SoundAsset;
    [Bindable] [Embed(source="assets/sound/NewFriendly96.mp3")] 
    private static var new_friendly:Class;

    ///////////////////////////////////////////////////////
    // METHODS
    ///////////////////////////////////////////////////////
    
    /** Initialize singleton sound manager. */
    public static function initialize():void  {
      // Music.
      newFriendly = SoundAsset(new new_friendly());
 
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
      stopMusic();
      
      musicChannel = newFriendly.play(0, (isLoop ? int.MAX_VALUE : 0));
    }
    
    /** Stops playing of all music. */
    public static function stopMusic():void {
      if (musicChannel != null) {
        musicChannel.stop();
      }
    }
    
    /** Plays a random bullet sound effect. */
    public static function playRandomBullet():void {
      bulletEffects[int(Math.random() * bulletEffects.length)].play();
    }

    /** Plays a random explosion sound effect. */
    public static function playRandomExplosion():void {
      explosionEffects[int(Math.random() * explosionEffects.length)].play();
    }
  }
}