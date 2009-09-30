package utils {
	
	import __AS3__.vec.Vector;
	
	import flash.media.SoundChannel;
	
	import mx.core.SoundAsset;
	import mx.effects.SoundEffect;
	
	public class SoundManager {
		
		///////////////////////////////////////////////////////
		// GUI
		///////////////////////////////////////////////////////
		
		[Bindable] public var buttonEffect:SoundEffect;
		[Bindable] [Embed(source="assets/sound/button.mp3")] private var button:Class;		
		
		///////////////////////////////////////////////////////
		// EFFECTS
		///////////////////////////////////////////////////////
		
		/** Channel for infect effects. */
		protected var infectChannel:SoundChannel;
		/** A vector of all infect sound effects. */
		protected var infects:Vector.<SoundAsset>;
		
		[Bindable] [Embed(source="assets/sound/infect_1.mp3")] private var infect_1:Class;
		
		/** Channel for launch effects. */
		protected var launchChannel:SoundChannel;
		/** A vector of all launch sound effects. */
		protected var launchs:Vector.<SoundAsset>;
		
		[Bindable] [Embed(source="assets/sound/launch_1.mp3")] private var launch_1:Class;
		[Bindable] [Embed(source="assets/sound/launch_2.mp3")] private var launch_2:Class;
		
		///////////////////////////////////////////////////////
		// MUSIC
		///////////////////////////////////////////////////////
		
		/** Channel for music. */
		protected var musicChannel:SoundChannel;
		
		protected var cautiousPath:SoundAsset;
		[Bindable] [Embed(source="assets/sound/cautious-path.mp3")] private var cautious_path:Class;
		
		protected var midnightRide:SoundAsset;
		[Bindable] [Embed(source="assets/sound/midnight-ride.mp3")]	private var midnight_ride:Class;
		
		///////////////////////////////////////////////////////
		// METHODS
		///////////////////////////////////////////////////////
		
		/** Create a new sound manager. */
		public function SoundManager()	{
			// Music.
			cautiousPath = SoundAsset(new cautious_path());
			midnightRide = SoundAsset(new midnight_ride());
			
			// Effects.			
			buttonEffect = new SoundEffect();
			buttonEffect.source = button;
			
			// Sound assets.
			infects = new Vector.<SoundAsset>();
			infects.push(SoundAsset(new infect_1()));
			
			launchs = new Vector.<SoundAsset>();
			launchs.push(SoundAsset(new launch_1()));
			launchs.push(SoundAsset(new launch_2()));
		}

		/** Plays splash screen music. */
		public function playSplashMusic():void {
			stopMusic();
			
			musicChannel = cautiousPath.play();
		}
		
		/** Plays game music. */
		public function playGameMusic():void {
			stopMusic();
			
			musicChannel = midnightRide.play();
		}
		
		/** Stops playing of all music. */
		public function stopMusic():void {
			if (musicChannel != null) {
				musicChannel.stop();
			}
		}
		
		/** Plays a random infect sound effect. */
		public function playRandomInfect():void {
			if (infectChannel != null) {
				infectChannel.stop();
			}
			
			infectChannel = infects[int(Math.random() * infects.length)].play();
		}
		
		/** Plays a random launch sound effect. */
		public function playRandomLaunch():void {
			if (launchChannel != null) {
				launchChannel.stop();
			}
			
			launchChannel = launchs[int(Math.random() * launchs.length)].play();
		}
	}
}