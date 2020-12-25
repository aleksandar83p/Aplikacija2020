export const StorageConfig = {
    photo:{
        destination: '../storage/photos/',
        urlPrefix: '/assets/photos',
        maxAge: 1000 * 60 * 60 * 24 * 7,  // 7 dana trajanje
        maxSize: 1024 * 1024 * 3, // u bajtovima, u ovom slucaju je 3 mb
        resize:{
            thumb: {
                width: 120,
                height: 100,
                directory: 'thumb/'
            },
            small:{
                width: 320,
                height: 240,
                directory: 'small/'
            },
        },
    },
};
// http://localhost:3000/assets/photos/imefotografike.jpg ili png


// maxAge - // kesiranje slike, koliko dugo da stoji u kes memoriji browsera nakon sto se ucita
// i ponovo se dobije zahtev za prikaz te slike

// 1000 milisenkudi * 60 - daje sekunde; 60 sec * 60 daje minute; 60 min * 24 daje sate; 24 sata * 7 daje dane
