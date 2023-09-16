document.addEventListener('DOMContentLoaded', () => {
window.onSpotifyWebPlaybackSDKReady = () => {

let player;
let positionA = null;
let positionB = null;
const token = document.getElementById('token-input').value;  // あなたのSpotify APIトークンをここに入れてください
const song_code = document.getElementById('song-code-input').value;


function initPlayer() {
  player = new Spotify.Player({
    name: 'Web Playback SDK',
    getOAuthToken: cb => { cb(token); }
  });

  // エラー処理
  player.addListener('initialization_error', ({ message }) => { console.error(message); });
  player.addListener('authentication_error', ({ message }) => { console.error(message); });
  player.addListener('account_error', ({ message }) => { console.error(message); });
  player.addListener('playback_error', ({ message }) => { console.error(message); });

  // 再生準備完了
  player.addListener('ready', ({ device_id }) => {
    console.log('Ready with Device ID', device_id);
  });

  // 再生状態変更
  player.addListener('player_state_changed', state => {
    console.log(state);
  });

  player.connect();
}

document.getElementById('play_button').addEventListener('click', () => {
  playSong(`spotify:track:${song_code}`);  // あなたのトラックURIをここに入れてください
});

document.getElementById('set_position_button').addEventListener('click', () => {
  setPosition();
});

function playSong(trackURI) {
  fetch(`https://api.spotify.com/v1/me/player/play?device_id=${player._options.id}`, {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`
    },
    body: JSON.stringify({ uris: [trackURI] }),
  });
}

function setPosition() {
  player.getCurrentState().then(state => {
    if (!state) {
      console.error('Player state is null');
      return;
    }

    if (positionA === null) {
      positionA = state.position;
      console.log(`A position set at ${positionA}ms`);
    } else if (positionB === null) {
      positionB = state.position;
      console.log(`B position set at ${positionB}ms`);
    } else {
      positionA = null;
      positionB = null;
      console.log('A and B positions reset');
    }
  });
}

initPlayer();

};
});
