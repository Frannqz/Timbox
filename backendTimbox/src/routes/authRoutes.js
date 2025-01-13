import express from 'express';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import client from '../database/db.js';

const router = express.Router();


//Registro de usuarios
router.post('/registro', async (req, res) => {
    const { nombre, email, rfc, password } = req.body;

    if (!nombre || !email || !rfc || !password) {
        return res.status(400).json({ error: 'Todos los campos son requeridos' });
    }

    try {
        const checkQuery = 'SELECT * FROM usuarios WHERE email = $1 OR rfc = $2';
        const result = await client.query(checkQuery, [email, rfc]);

        if (result.rows.length > 0) {
            return res.status(400).json({ error: 'Correo o RFC ya están registrados' });
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const insertQuery = `
            INSERT INTO usuarios (nombre, email, rfc, password)
            VALUES ($1, $2, $3, $4) RETURNING *;
        `;
        const newUser = await client.query(insertQuery, [nombre, email, rfc, hashedPassword]);

        res.status(201).json({ message: 'Usuario registrado exitosamente', user: newUser.rows[0] });
    } catch (err) {
        console.error('Error al registrar usuario', err);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

//Iniciar sesion
router.post('/login', async (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ error: 'Correo electrónico y contraseña son requeridos' });
    }

    try {
        const result = await client.query('SELECT * FROM usuarios WHERE email = $1', [email]);
        const user = result.rows[0];

        if (!user) {
            return res.status(400).json({ error: 'Credenciales incorrectas' });
        }

        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({ error: 'Credenciales incorrectas' });
        }

        const token = jwt.sign({ userId: user.id }, 'secret', { expiresIn: '1h' });

        res.json({ token, userId: user.id });

    } catch (err) {
        console.error('Error al iniciar sesión', err);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

export default router;
