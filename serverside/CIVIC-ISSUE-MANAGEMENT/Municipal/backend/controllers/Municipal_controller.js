const MunicipalModel = require("../models/Municipal.js");

const fetchallDistricts = async (req, res) => {
    try {
        const districts = await MunicipalModel.find({});
        console.log(districts);
        return res.json({success: true,districts: districts});
    } catch (error) {
        console.error("Error fetching districts:", error);
        return res.status(500).json({ success: false, error: "Internal server error" });
    }
}
module.exports = { fetchallDistricts };

const LoginMunicipal = async (req, res) => {  
      const {username,password} = req.body;
      console.log(username,password);
      const user = await MunicipalModel.findOne({official_username: username});
      if(!user){
        return res.status(401).json({success:false,message:"User not found"});
      }
      const isMatch = await bcrypt.compare(password, user.password);
      if (!isMatch) return res.status(401).json({ message: "Invalid password" });
      const tokens = jwt.sign({username,password},process.env.JWT_SECRET);
      console.log(tokens + " Generated during login");
      console.log(req.body);
      res.json({success:true,tokens});

}

