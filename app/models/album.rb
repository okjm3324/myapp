class Album < ApplicationRecord

  enum genre: { pops: 0, rock: 1, jazz: 2, funk: 3, hiphop: 4, RandB:5, dance:6, HR:7, metal:8, classic:9, country:10, electronica:11  }
end
