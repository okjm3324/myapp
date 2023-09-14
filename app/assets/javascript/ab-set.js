window.onSpotifyWebPlaybackSDKReady = () => {

  const token = document.getElementById('access-token-input').value; 
  const track_id = document.getElementById('song-code-input').value; 
  const player = new Spotify.Player({
    name: 'Web Playback SDK Quick Start Player',
    getOAuthToken: cb => { cb(token); }
  });

  // エラーハンドリング
  player.addListener('initialization_error', ({ message }) => { console.error(message); });
  player.addListener('authentication_error', ({ message }) => { console.error(message); });
  player.addListener('account_error', ({ message }) => { console.error(message); });
  player.addListener('playback_error', ({ message }) => { console.error(message); });

  // 再生が準備完了したらコンソールに表示
  player.addListener('ready', ({ device_id }) => {
    console.log('Ready with Device ID', device_id);
  });

  // セッションが終了したらコンソールに表示
  player.addListener('not_ready', ({ device_id }) => {
    console.log('Device ID has gone offline', device_id);
  });

  // Connect to the player!
  player.connect();

  // A位置とB位置を格納する変数
  let start_position, end_position;

  // A位置を設定する関数
  function setStartPosition() {
    player.getCurrentState().then(state => {
      if (!state) {
        console.error('User is not playing music through the Web Playback SDK');
        return;
      }
      
      start_position = state.position;
      document.getElementById('start_position').value = start_position;
    });
  }

  // B位置を設定する関数
  function setEndPosition() {
    player.getCurrentState().then(state => {
      if (!state) {
        console.error('User is not playing music through the Web Playback SDK');
        return;
      }
      
      end_position = state.position;
      document.getElementById('end_position').value = end_position;
    });
  }

  // HTMLのボタンに関連付ける
  document.getElementById('set_start_position_button').onclick = setStartPosition;
  document.getElementById('set_end_position_button').onclick = setEndPosition;
};
