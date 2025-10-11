import React from 'react'

const Login = () => {
  return (
    <div
      className="min-h-screen flex items-center justify-center bg-gray-100"
      style={{
        backgroundImage:
          "url('https://content3.jdmagicbox.com/v2/comp/gandhinagar-gujarat/a1/9999pxx79.xx79.110217142119.q3a1/catalogue/chief-minister-office-gandhinagar-sector-10-gandhinagar-gujarat-government-organisations-wjmily0h72.jpg')",
        backgroundSize: "cover",
        backgroundPosition: "center",
        
      }}
    >
      <form className="bg-transparent bg-opacity-95 rounded-xl border-2 shadow-white shadow-xl p-8 w-full max-w-md flex flex-col gap-9 text-white">
        <h2 className="text-4xl font-bold text-center mb-2">STATE LOGIN</h2>
        <div>
          <label htmlFor="email" className="block text-sm font-medium mb-1">
            Email
          </label>
          <input
            type="email"
            id="email"
            name="email"
            className="w-full px-4 py-2 border-2 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            required
            autoComplete="email"
          />
        </div>
        <div>
          <label htmlFor="password" className="block text-sm font-medium mb-1">
            Password
          </label>
          <input
            type="password"
            id="password"
            name="password"
            className="w-full px-4 py-2 border-2 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            required
            autoComplete="current-password"
          />
        </div>
        <div>
          <label htmlFor="password" className="block text-sm font-medium mb-1">
            OTP
          </label>
          <input
            type="number"
            id="otp"
            name="otp"
            className="w-full px-4 py-2 border-2 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            required
            
          />
        </div>
        <button
          type="submit"
          className="w-full bg-blue-600 text-white font-semibold py-2 rounded-lg hover:bg-blue-700 transition-colors"
        >
          Login
        </button>
        {/* <div className="text-center mt-2">
          <a href="#" className="text-sm text-blue-600 hover:underline">
            Forgot password?
          </a>
        </div> */}
      </form>
    </div>
  )
}

export default Login