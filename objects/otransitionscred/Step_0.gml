if (transitioning) {
    alpha += transitionSpeed;
    if (alpha >= 1) {
      
        room_goto(nextRoom);
		audio_stop_sound(sndMenu)
        
    }
} else if (alpha > 0) {
    alpha -= transitionSpeed;
    if (alpha < 0) alpha = 0;
}
