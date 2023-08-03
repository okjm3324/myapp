

  window.onSpotifyWebPlaybackSDKReady = () => {
    const token = gon.access_token; // アクセストークンをRailsビューから渡す
    const player = new Spotify.Player({
      name: 'Web Playback SDK Quick Start Player',
      getOAuthToken: cb => { cb(token); },
      volume: 0.5
    });

    let isPlaying = false; // 再生中かどうかのフラグ
    let interval; // 繰り返し再生用のタイマー
    const startTime = 10; // 繰り返し再生の開始位置（秒）
    const endTime = 20; // 繰り返し再生の終了位置（秒）

    // Ready
    player.addListener('ready', ({ device_id }) => {
      console.log('Ready with Device ID', device_id);

      // 曲の再生
      const trackId = gon.track_id; // 曲のIDをRailsビューから渡す
      player._options.getOAuthToken(access_token => {
        fetch(`https://api.spotify.com/v1/me/player/play?device_id=${device_id}`, {
          method: 'PUT',
          body: JSON.stringify({ uris: [`spotify:track:${trackId}`] }),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${access_token}`
          },
        });
      });

      // 繰り返し再生の開始
      startLoopPlayback(player);
    });

    // 繰り返し再生の開始
    function startLoopPlayback(player) {
      // 繰り返し再生用のタイマーを設定
      interval = setInterval(() => {
        player.getCurrentState().then(state => {
          if (state && state.position >= endTime * 1000) {
            player.seek(startTime * 1000);
          }
        });
      }, 1000);
    }

    // 再生トグルボタンのクリックイベント
    document.getElementById('togglePlay').onclick = function() {
      if (isPlaying) {
        player.pause();
        clearInterval(interval);
      } else {
        player.resume();
        startLoopPlayback(player);
      }
      isPlaying = !isPlaying;
    };

    // SDKの初期化と接続
    player.connect();
  }
