
const { fetchallDistricts } = require("../controllers/Municipal_controller");

const express = require("express");

const MunicipalRouter = express.Router();

MunicipalRouter.get("/allDistricts", fetchallDistricts);
MunicipalRouter.post("/login",LoginMunicipal)
module.exports = MunicipalRouter;


