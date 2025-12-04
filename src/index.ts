import express from "express";

const app = express();
const PORT = process.env.PORT || 3000;

// GET /health
app.get("/health", (_req, res) => {
	res.json({ status: "ok" });
});

// GET /test
app.get("/test", (_req, res) => {
	console.log("Test endpoint hit at ", new Date().toISOString());
	res.json({ message: "test logged" });
});

app.listen(PORT, () => {
	console.log('API running on http://localhost:${PORT}');
});
