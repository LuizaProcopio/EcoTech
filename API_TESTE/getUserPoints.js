import express from "express";
import mysql from "mysql2";

const app = express();

const db = mysql.createConnection({
  host: "seu-host",
  user: "seu-usuario",
  password: "sua-senha",
  database: "seu-banco"
});

app.get("/user/:id", (req, res) => {
  const userId = req.params.id;

  const sql = `
    SELECT 
      u.nome,
      p.pontos_totais + COALESCE(SUM(d.pontos_ganhos), 0) AS pontos
    FROM usuarios u
    JOIN perfil p ON p.id_usuario = u.id_usuario
    LEFT JOIN descartes d ON d.id_usuario = u.id_usuario
    WHERE u.id_usuario = ?
    GROUP BY u.nome, p.pontos_totais;
  `;

  db.query(sql, [userId], (err, result) => {
    if (err) return res.status(500).json({ error: err });

    res.json(result[0]);
  });
});

app.listen(3000, () => console.log("API rodando!"));