import express from 'express';
import client from '../database/db.js';

const router = express.Router();


//Insert Collaborator
router.post('/addCollaborator', async (req, res) => {
    const {
        nombre,
        correo,
        rfc,
        domicilio_fiscal,
        curp,
        nss,
        fecha_inicio_laboral,
        tipo_contrato,
        departamento,
        puesto,
        salario_diario,
        salario,
        clave_entidad,
        estado,
        user_id,
    } = req.body;

    if (!nombre || !correo || !rfc || !domicilio_fiscal || !curp || !nss || !fecha_inicio_laboral) {
        return res.status(400).json({ error: 'Todos los campos obligatorios deben estar presentes' });
    }


    try {
        const query = `
            INSERT INTO colaboradores (
                nombre, correo, rfc, domicilio_fiscal, curp, nss,
                fecha_inicio_laboral, tipo_contrato, departamento, puesto,
                salario_diario, salario, clave_entidad, estado, user_id
            ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)
            RETURNING *;
        `;

        const values = [
            nombre, correo, rfc, domicilio_fiscal, curp, nss,
            fecha_inicio_laboral, tipo_contrato, departamento, puesto,
            salario_diario, salario, clave_entidad, estado, user_id,
        ];

        const result = await client.query(query, values);

        console.log('Valores para insertar:', values);

        res.status(201).json({
            message: 'Colaborador agregado exitosamente',
            colaborador: result.rows[0],
        });
    } catch (err) {
        console.error('Error al agregar colaborador:', err);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

router.get('/collaborators', async (req, res) => {
    const { user_id } = req.query;

    if (!user_id) {
        return res.status(400).json({ error: 'User ID es obligatorio' });
    }

    try {
        const query = 'SELECT * FROM colaboradores WHERE user_id = $1';
        const result = await client.query(query, [user_id]);

        res.json(result.rows);
    } catch (err) {
        console.error('Error al obtener colaboradores:', err);
        res.status(500).send('Error al obtener colaboradores');
    }
});


export default router;
