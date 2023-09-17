document.addEventListener("turbo:load", () => {
let player;

window.onSpotifyWebPlaybackSDKReady = () => {
  const token = document.getElementById('access-token-input').value; 
  let track_id = document.getElementById('song-code-input').value; 

  player = new Spotify.Player({
      name: 'Web Playback SDK Quick Start Player',
      getOAuthToken: cb => { cb(token); }
  });

  // Error handling
  player.addListener('initialization_error', ({ message }) => { console.error(message); });
  player.addListener('authentication_error', ({ message }) => { console.error(message); });
  player.addListener('account_error', ({ message }) => { console.error(message); });
  player.addListener('playback_error', ({ message }) => { console.error(message); });

  // Playback status updates
  player.addListener('player_state_changed', state => {
    console.log(state);
    const currentTime = state.position;
    const totalTime = state.duration;
    document.querySelector('.current-time').textContent = formatTime(currentTime);
    document.querySelector('.total-time').textContent = formatTime(totalTime);
    document.querySelector('#seekbar').max = totalTime;
    document.querySelector('#seekbar').value = currentTime;
  });

  // Ready
  player.addListener('ready', ({ device_id }) => {
    console.log('Ready with Device ID', device_id);

    document.getElementById('play-button').addEventListener('click', () => {
      track_id = document.getElementById('song-code-input').value;
      fetch(`https://api.spotify.com/v1/me/player/play?device_id=${device_id}`, {
        method: 'PUT',
        body: JSON.stringify({ uris: [`spotify:track:${track_id}`] }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        },
      }).then(() => {
        console.log('Track played');
      }).catch(err => {
        console.error(err);
      });
    });
  });

  // Connect to the player
  player.connect();
};

// Function to format time in ms to a string "MM:SS"
function formatTime(ms) {
  const minutes = Math.floor(ms / 60000);
  const seconds = ((ms % 60000) / 1000).toFixed(0);
  return minutes + ':' + (seconds < 10 ? '0' : '') + seconds;
}

// Add an input event listener to the seekbar to seek to a new position when the user drags the seekbar
document.querySelector('#seekbar').addEventListener('input', (e) => {
  const newPositionMs = e.target.value;
  player.seek(newPositionMs).then(() => {
    console.log('Set the position to ' + newPositionMs);
  });
});
});
