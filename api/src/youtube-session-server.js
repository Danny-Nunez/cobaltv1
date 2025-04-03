import { Innertube } from "youtubei.js";
import express from "express";

const app = express();
const port = process.env.PORT || 9000;

let session = null;
let lastUpdate = 0;

async function generateSession() {
    try {
        const yt = await Innertube.create({
            client: process.env.YOUTUBE_SESSION_INNERTUBE_CLIENT || "WEB",
            retrieve_player: true
        });

        const context = yt.session.context;
        session = {
            potoken: context.potoken,
            visitor_data: context.visitor_data,
            updated: Date.now()
        };
        lastUpdate = Date.now();
        console.log("Generated new YouTube session");
    } catch (error) {
        console.error("Failed to generate YouTube session:", error);
    }
}

// Generate initial session
generateSession();

// Set up periodic session refresh
const refreshInterval = (process.env.YOUTUBE_SESSION_RELOAD_INTERVAL || 300) * 1000;
setInterval(generateSession, refreshInterval);

app.get("/token", (req, res) => {
    if (!session) {
        return res.status(503).json({ error: "Session not available" });
    }
    res.json(session);
});

app.listen(port, () => {
    console.log(`YouTube session server listening on port ${port}`);
}); 