import express from 'express';
import cors from 'cors';
import usersRoutes from './src/routes/usersRoutes.js';

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

app.use('/api', usersRoutes);

app.listen(port, () => {
    console.log(`Servidor escuchando en http://localhost:${port}`);
});
