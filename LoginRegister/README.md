# Backend Login Register
Project ini adalah backend logres menggunakan Firebase Authentication dengan Node.js. 

## Fitur

* Registrasi user baru dengan email dan password.
* Login user.
* verifikasi pin.
* Verifikasi idcard/pasport.

## Teknologi

* Node.js
* Firebase Authentication
* ExpressJs
* Cloud Storage

## Instalasi

1. Clone repository ini: `git clone <URL_repository>`
2. Install dependencies: `npm install`
3. Buat project Firebase dan aktifkan Authentication.
4. Buat Credential Service Accounts dan taruh di config
5. Buat file `.env` dan isi dengan konfigurasi Firebase-mu:
FIREBASE_API_KEY=<API_KEY>
FIREBASE_AUTH_DOMAIN=<AUTH_DOMAIN>
FIREBASE_PROJECT_ID=<PROJECT_ID>
FIREBASE_STORAGE_BUCKET=<STORAGE_BUCKET>
FIREBASE_MESSAGING_SENDER_ID=<MESSAGING_SENDER_ID>
FIREBASE_APP_ID=<APP_ID> 1  

## Menjalankan Aplikasi

`npm run start`


## Kontributor

* Ahmad Rofik Harahap (CC) - Universitas Muhammadiyah Prof Dr Hamka
* Raynaldi Felim (CC) - Universitas Prima Indonesia
