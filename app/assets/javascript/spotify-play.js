document.addEventListener('DOMContentLoaded', function() {
  // Web Playback SDK の準備が完了したときの処理
  window.onSpotifyWebPlaybackSDKReady = () => {
    const access_token = document.querySelector('#access-token-input').value;
    const track_id = document.querySelector('#track-id-input').value;
    const song_code = document.querySelector('#song-code-input').value;
    const player = new Spotify.Player({
      name: 'Web Playback SDK Quick Start Player',
      getOAuthToken: cb => { cb(access_token); },
      volume: 0.5
    });
    const startTime = 30;
    const endTime = 40;
    let interval;
    let isPlaying = false;
    let isLooping = false;

    // SDK の Ready イベント
    player.addListener('ready', ({ device_id }) => {
      console.log('Ready with Device ID', device_id);

      const trackBox = document.querySelector(`#track-box-${track_id}`);
      trackBox.addEventListener('click', () => {
        console.log('へい');
        player._options.getOAuthToken(access_token => {
          if (!isPlaying) {
            // 再生
            fetch(`https://api.spotify.com/v1/me/player/play?device_id=${device_id}`, {
              method: 'PUT',
              body: JSON.stringify({ uris: [`spotify:track:${song_code}`], position_ms: startTime * 1000 }),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${access_token}`
              },
            }).then(response => {
              if (response.status === 204) {
                console.log('再生中');
                isPlaying = true;
                startLoopPlayback(player, startTime, endTime);
              }
            });
          } else {
            // 一時停止
            fetch(`https://api.spotify.com/v1/me/player/pause?device_id=${device_id}`, {
              method: 'PUT',
              headers: {
                'Authorization': `Bearer ${access_token}`
              },
            }).then(response => {
              if (response.status === 204) {
                console.log('一時停止');
                isPlaying = false;
                clearInterval(interval);
              }
            }).catch(error => {
              console.log('fetch error:', error);
            });
          }
        });
      });

    });

    // SDK の初期化と接続
    player.connect();

    // 繰り返し再生の開始
    function startLoopPlayback(player, startTime, endTime) {
      isLooping = true;
      interval = setInterval(() => {
        player.getCurrentState().then(state => {
          if (state && isLooping && state.position >= endTime * 1000) {
            player.seek(startTime * 1000);
            console.log('ループ再生');
          }
        });
      }, 1000);
    }
  };
});
