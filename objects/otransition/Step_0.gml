if (transitioning) {
    alpha += transitionSpeed;
    if (alpha >= 1) {
      
        room_goto(nextRoom);
        audio_play_sound(Novojogo, 1, false);
    }
} else if (alpha > 0) {
    alpha -= transitionSpeed;
    if (alpha < 0) alpha = 0;
}
