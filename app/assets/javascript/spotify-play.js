document.addEventListener("turbo:load", () => {
  let player;
  let device_id;
  let isTrackLoaded = false;
  let isPaused = false; 
  const startTime = 30;
  const endTime = 35; 

  const access_token = document.getElementById('access-token-input').value; 
  const track_id = document.getElementById('song-code-input').value; 

  let timer;
  let pauseTime; // 追加

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
          pauseTime = state.position; // 一時停止時の位置を記録
        }
      }
    });

    player.addListener('initialization_error', ({ message }) => {
      console.error('Initialization error', message);
    });

    player.connect();
  };

  function setLoopTimeout() {
    let playDuration = (endTime * 1000) - pauseTime; // 経過時間を考慮した再生時間を計算
    timer = setTimeout(() => {
      player.pause().then(() => {
        console.log('Paused at B position');
        player.seek(startTime * 1000).then(() => {
          console.log(`Reset to A position: ${startTime}s`);
        });
      });
    }, playDuration);
    pauseTime = 0; // タイマーをリセット
  }

  function loadTrack() {
    fetch(`https://api.spotify.com/v1/me/player/play?device_id=${device_id}`, {
      method: 'PUT',
      body: JSON.stringify({ uris: [`spotify:track:${track_id}`], position_ms: startTime * 1000 }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${access_token}`
      },
    }).then(() => {
      console.log('Track loaded');
      isTrackLoaded = true;
      pauseTime = startTime * 1000; // pauseTimeを初期化
      setLoopTimeout();
    }).catch((error) => {
      console.error('Failed to load track', error);
    });
  }

  document.getElementById('start-loop-button').addEventListener('click', () => {
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
});
