require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const app = express();
app.use(express.json());
app.use(cors());

// Koneksi ke Supabase / PostgreSQL
const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
});

// ==========================================
// 1. MIDDLEWARE: CEK TOKEN (KEAMANAN)
// ==========================================
function authenticateToken(req, res, next) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (token == null) {
        return res.status(401).json({ status: false, message: "Akses ditolak. Token tidak ada." });
    }

    jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
        if (err) {
            return res.status(403).json({ status: false, message: "Token tidak valid atau kadaluarsa." });
        }
        req.user = user;
        next();
    });
}

// ==========================================
// 2. API ROUTES
// ==========================================

// --- API LOGIN ---
app.post('/login', async (req, res) => {
    const { email, password } = req.body;

    try {
        // Optimasi: Tambahkan LIMIT 1 karena email harusnya unik
        const user = await pool.query('SELECT * FROM users WHERE email = $1 LIMIT 1', [email]);
        
        // 1. Cek Email
        if (user.rows.length === 0) {
            return res.status(401).json({ status: false, message: "Email tidak terdaftar" });
        }

        const userData = user.rows[0];

        // 2. Cek Password
        const validPassword = await bcrypt.compare(password, userData.password);
        if (!validPassword) {
            return res.status(401).json({ status: false, message: "Password salah" });
        }

        // 3. Buat Token
        // PERBAIKAN: Saya samakan key 'satuan' menjadi 'satuan_kerja' biar konsisten
        const token = jwt.sign(
            { 
                id: userData.id, 
                role: userData.role,
                satuan_kerja: userData.satuan_kerja 
            }, 
            process.env.JWT_SECRET, 
            { expiresIn: '7d' }
        );

        // 4. Response
        res.json({ 
            status: true, 
            message: "Login Berhasil", 
            token: token,
            data: {
                nama: userData.nama,
                role: userData.role,
                satuan_kerja: userData.satuan_kerja
            }
        });

    } catch (err) {
        console.error(err);
        res.status(500).json({ status: false, message: "Server Error: " + err.message });
    }
});

// --- API DASHBOARD STATS ---
app.get('/dashboard/stats', authenticateToken, async (req, res) => {
    try {
        // Data Dummy (Sesuai Model Flutter)
        const dummyData = {
            total_luas_tanam: 15420.5,
            total_luas_panen: 8900.0,
            potensi_lahan: 25000.0,
            total_hasil_panen: 4500.0,
            jumlah_personel: 125
        };

        res.json({
            status: true,
            message: "Data Dashboard Berhasil Dimuat",
            data: dummyData
        });

    } catch (err) {
        console.error(err);
        res.status(500).json({ status: false, message: "Gagal memuat dashboard" });
    }
});

// --- ROOT CHECK ---
app.get('/', (req, res) => {
    res.send("Server Presisi Jalan Bos!");
});

// ==========================================
// 3. SERVER LISTEN
// ==========================================
const PORT = process.env.PORT || 3000;

// Tetap gunakan '0.0.0.0' agar Emulator Android bisa masuk
app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server Presisi sudah jalan di port ${PORT}`);
});