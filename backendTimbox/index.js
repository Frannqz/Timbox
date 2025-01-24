import express from 'express';
import cors from 'cors';
import usersRoutes from './src/routes/usersRoutes.js';
import authRoutes from './src/routes/authRoutes.js';
import filesRoutes from './src/routes/filesRoutes.js';
import collaboratorsRoutes from './src/routes/collaboratorsRoutes.js';

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

app.use('/api', usersRoutes);
app.use('/api', authRoutes);
app.use('/api', filesRoutes);
app.use('/api', collaboratorsRoutes);

app.listen(port, () => {
    console.log(`Servidor escuchando en http://localhost:${port}`);
});
