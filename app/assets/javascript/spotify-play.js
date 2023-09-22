document.addEventListener("turbo:load", () => {
  let player;
  let device_id;
  let isTrackLoaded = false;
  let isPaused = false;

  const startTimeElement = document.getElementById('start-time-input');
  if (!startTimeElement) {
      console.error("start-time-input element not found");
      return;
  }
  const startTime = startTimeElement.value;

  const endTimeElement = document.getElementById('end-time-input');
  if (!endTimeElement) {
      console.error("end-time-input element not found");
      return;
  }
  const endTime = endTimeElement.value;

  const accessTokenElement = document.getElementById('access-token-input');
  if (!accessTokenElement) {
      console.error("access-token-input element not found");
      return;
  }
  const access_token = accessTokenElement.value;

  const trackIdElement = document.getElementById('song-code-input');
  if (!trackIdElement) {
      console.error("song-code-input element not found");
      return;
  }
  const track_id = trackIdElement.value;

  let timer;
  let pauseTime;

  window.onSpotifyWebPlaybackSDKReady = () => {
    player = new Spotify.Player({
      name: 'Web Playback SDK Quick Start Player',
      getOAuthToken: cb => { cb(access_token); },
      volume: 0.5
    });

    player.addListener('ready', ({ device_id: id }) => {
      console.log('Ready with Device ID', id);
      device_id = id;
    });

    player.addListener('player_state_changed', state => {
      console.log('Player state changed', state);
      if (state) {
        isPaused = state.paused;
        if (isPaused) {
          pauseTime = state.position;
        }
      }
    });

    player.addListener('initialization_error', ({ message }) => {
      console.error('Initialization error', message);
    });

    player.connect();
  };

  function setLoopTimeout() {
    let playDuration = (endTime) - pauseTime;
    timer = setTimeout(() => {
      player.pause().then(() => {
        console.log('Paused at B position');
        player.seek(startTime).then(() => {
          console.log(`Reset to A position: ${startTime}s`);
        });
      });
    }, playDuration);
    pauseTime = 0;
  }

  function loadTrack() {
    fetch(`https://api.spotify.com/v1/me/player/play?device_id=${device_id}`, {
      method: 'PUT',
      body: JSON.stringify({ uris: [`spotify:track:${track_id}`], position_ms: startTime }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${access_token}`
      },
    }).then(() => {
      console.log('Track loaded');
      isTrackLoaded = true;
      pauseTime = startTime;
      setLoopTimeout();
    }).catch((error) => {
      console.error('Failed to load track', error);
    });
  }

  const startLoopButton = document.getElementById('start-loop-button');
  if (startLoopButton) {
    startLoopButton.addEventListener('click', () => {
      if (!isTrackLoaded) {
        loadTrack();
      } else {
        player.togglePlay().then(() => {
          console.log('Toggled play/pause');
          clearTimeout(timer);
          if (isPaused) {
            setLoopTimeout();
          }
        });
      }
    });
  } else {
    console.error("start-loop-button element not found");
  }
});
