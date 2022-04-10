import {resolve} from "path";

import {config} from "dotenv";

config({path: resolve(__dirname, "../.env")});

export default {
    ENV: process.env.ENV
};
