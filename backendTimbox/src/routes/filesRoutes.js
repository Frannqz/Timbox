import express from 'express';
import client from '../database/db.js';

const router = express.Router();

//Obtener archivos
router.get('/files', async (req, res) => {
    try {
        const result = await client.query('SELECT * FROM archivos');
        res.json(result.rows);
    } catch (err) {
        console.error('Error al obtener los archivos', err);
        res.status(500).send('Error al obtener archivos');
    }
});

//Registrar archivo
router.post('/registerFile', async (req, res) => {
    const { nombre_archivo, extension } = req.body;

    if (!nombre_archivo || !extension) {
        return res.status(400).json({ error: 'El nombre y la extensión son requeridos' });
    }

    try {
        const query = `
            INSERT INTO archivos (nombre_archivo, extension)
            VALUES ($1, $2)
            RETURNING *;
        `;
        const result = await client.query(query, [nombre_archivo, extension]);

        res.status(201).json({
            message: 'Archivo registrado exitosamente',
            archivo: result.rows[0],
        });
    } catch (err) {
        console.error('Error al registrar archivo', err);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});
export default router;
