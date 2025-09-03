# 💰 GrameenLend – Smart Rural Credit  
> 🤖 An AI-powered **loan underwriting & lending app** built for **rural and semi-urban India**, designed to work on **low-bandwidth networks** and for users with **low digital literacy**.  

---

## 📖 Overview  
**GrameenLend** is your **personal financial companion app** that blends **AI-driven credit scoring, SMS chatbot support, and instant disbursements** to make small-ticket personal loans **accessible, fast, and transparent**.  

It has been carefully designed with:  
- 🌍 **Rural-first approach** (works offline with SMS/WhatsApp chatbot)  
- 📱 **Accessibility-first UI** (voice input, pictogram-based, simple navigation)  
- 🔒 **Privacy & compliance** (secure KYC, RBI-aligned lending protocols)  

Our mission is simple: **make credit accessible, affordable, and inclusive for underserved communities**.  

---

## ✨ Features  

- 📲 **Mobile-first Lending** → Works smoothly on low-spec Android devices  
- 📑 **Seamless KYC** → Aadhaar, PAN, Bank Passbook uploads with offline fallback  
- 🤖 **AI Underwriting** → Instant credit scoring & loan eligibility checks  
- 🗣️ **LLM-Powered Assistant** → Explains loan terms in local languages & voice format  
- 💬 **Offline Loan Request** → SMS chatbot support for users without internet  
- ⚡ **Quick Disbursement** → Loan amount credited within **24 hours**  
- 🔔 **Smart Notifications** → Loan status updates via SMS & WhatsApp  

---

## 🏗️ Tech Stack  

**Frontend:** React Native / Flutter (lightweight mobile app)  
**Backend:** FastAPI / Node.js (APIs for loan processing & KYC)  
**AI / ML Models:** Credit Risk Scoring (custom), LLM (loan explanations)  
**Database:** PostgreSQL + Redis (cache)  
**Messaging:** Twilio / Gupshup (SMS & WhatsApp chatbot)  
**Infra:** AWS / GCP (Serverless APIs, S3/Cloud Storage, Kubernetes)  

---

## 🔄 Loan Application Flow  

1. **User Onboarding** → Register/Login with OTP & biometric options  
2. **Document Upload** → Aadhaar, PAN, Bank Passbook, Profile Picture (offline fallback via SMS/WhatsApp bot)  
3. **Loan Request** →  
   - Online (App): Select type, amount, tenure, purpose  
   - Offline (SMS Chatbot): Verified users can send loan request by SMS  
4. **Verification** → Automated document + KYC check  
5. **AI Underwriting** → Risk scoring & loan terms explained in simple language  
6. **Approval & Disbursement** → Loan processed & disbursed within 24 hrs  
7. **Notifications** → Updates sent via SMS & WhatsApp  

---

## 📸 Screenshots & Diagrams *(Coming Soon)*  

---

## 🚀 Getting Started  

### 1️⃣ Clone the Repository  
```bash
git clone https://github.com/your-username/grameenlend.git
cd grameenlend
```

### 2️⃣ Install Dependencies

```bash
# Backend
cd backend
pip install -r requirements.txt

# Frontend
cd frontend
npm install
```

### 3️⃣ Configure Environment Variables

Create a `.env` file in the root:

```
DB_URL=your-db-url
REDIS_URL=your-redis-url
AI_API_KEY=your-ai-key
SMS_GATEWAY_KEY=your-sms-key
```

### 4️⃣ Run the App

```bash
# Run backend
uvicorn main:app --reload

# Run frontend
npm start
```

---

## 🧑‍💻 Roadmap

* [x] Wireframes for app & chatbot
* [x] Loan application flow (App + SMS Chatbot)
* [ ] AI underwriting model integration
* [ ] LLM-powered loan explanation in regional languages
* [ ] UPI-based repayments
* [ ] Multilingual voice assistant

---

## 📊 Impact

* 🌍 Aiming to reach **100M+ underserved Indians** with affordable loans
* ⚡ Loan approvals within **1–24 hours** vs. weeks in traditional banks
* 🔒 Built on **secure, compliant, and inclusive lending principles**
* 📉 Reducing reliance on informal high-interest lending in rural areas

---

## 🤝 Contributing

We welcome contributors from **AI, fintech, mobile development & design** backgrounds!

1. Fork this repository
2. Create a feature branch (`feature/your-feature`)
3. Commit and push your changes
4. Open a Pull Request 🎉

---

## 📜 License

This project is licensed under the **MIT License**.  
You are free to use, modify, and distribute this software with attribution.  

---

## ⭐ Support

If you find this project meaningful, please ⭐ the repo and support **inclusive finance in India** 💙.
