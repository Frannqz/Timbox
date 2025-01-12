import express from 'express';
import bcrypt from 'bcrypt';
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

export default router;
