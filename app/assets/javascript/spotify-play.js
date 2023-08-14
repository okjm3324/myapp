document.addEventListener('DOMContentLoaded', function() {
  // Web Playback SDK の準備が完了したときの処理
  window.onSpotifyWebPlaybackSDKReady = () => {
    const access_token = document.querySelector('#access-token-input').value;
    const track_id = document.querySelector('#track-id-input').value
    const song_code = document.querySelector('#song-code-input').value
    const player = new Spotify.Player({
      name: 'Web Playback SDK Quick Start Player',
      getOAuthToken: cb => { cb(access_token); },
      volume: 0.5
    });

    let interval;
    const startTime = 10;
    const endTime = 20;

    // SDK の Ready イベント
    player.addListener('ready', ({ device_id }) => {
      console.log('Ready with Device ID', device_id);

      const trackBox = document.querySelector(`#track-box-${track_id}`);
      trackBox.addEventListener('click', () => {
        console.log('へい');
        const trackId = trackBox.getAttribute('data-track-id');
        player._options.getOAuthToken(access_token => {
          fetch(`https://api.spotify.com/v1/me/player/play?device_id=${device_id}`, {
            method: 'PUT',
            body: JSON.stringify({ uris: [`spotify:track:${song_code}`] }),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': `Bearer ${access_token}`
            },
          });
        });

        // player が存在する場合のみ繰り返し再生の開始
        if (player) {
          player.getCurrentState().then(state => {
            if (state) {
              // state を使った処理を行う
              startLoopPlayback(player, startTime, endTime);
            }
          });
        }
      });

    });

    // SDK の初期化と接続
    player.connect();

    // 繰り返し再生の開始
    function startLoopPlayback(player, startTime, endTime) {
      interval = setInterval(() => {
        player.getCurrentState().then(state => {
          if (state && state.position >= endTime * 1000) {
            player.seek(startTime * 1000);
          }
        });
      }, 1000);
    }
  };
});
