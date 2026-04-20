# =============================================================================
# CRYPTO MECCA WALLET - COOLIFY DEPLOYMENT GUIDE
# =============================================================================
# Coolify Panel: panel.softwarepros.org (your Coolify URL)
# App Domain: cal.zerodayinstitute.com (public URL)
# Repository: github.com/softwareprosdev/flutterwebapplication
# =============================================================================

## 📋 QUICK START (5 Steps)

### Step 1: Create New Application
1. Go to: https://panel.softwarepros.org
2. Click: "+ Create New Resource"
3. Select: "Application"
4. Name: "Crypto Mecca Wallet"
5. Click: "Create"

### Step 2: Connect GitHub Repository
1. Select: "GitHub" as source
2. Repository: softwareprosdev/flutterwebapplication
3. Branch: main
4. Click: "Save"

### Step 3: Configure Build Pack
1. Build Pack: Select "Dockerfile"
2. Click: "Save"

### Step 4: Set Environment Variables (Optional)
```
FLUTTER_WEB_USE_SKIA=true
```
Click Save.

### Step 5: Deploy
1. Click: "Deploy" button (top right)
2. Wait ~3-5 minutes for first build
3. Check logs for "Deployed successfully"

---

## 🌐 DOMAIN CONFIGURATION

### Step 1: Add Domain in Coolify
1. Go to App → Settings → Domains
2. Click: "Add Domain"
3. Enter: cal.zerodayinstitute.com
4. Click: "Save"

### Step 2: Configure Cloudflare DNS
Add the following DNS records in Cloudflare:

| Type | Name | Value | Proxy Status |
|------|------|-------|-------------|
| A | cal | `<YOUR_COOLIFY_IP>` | 🟠 DNS Only (gray) |
| CNAME | www | cal.zerodayinstitute.com | 🟠 DNS Only (gray) |

**Important:** Use DNS Only (gray cloud) - NOT proxied!

### Step 3: SSL Certificate
- Coolify auto-enables Let's Encrypt
- Allow ~2 minutes after domain added
- Check: Settings → HTTPS → "Enabled"

---

## 🔧 MANUAL DOCKERFILE (If Needed)

If Docker build pack has issues, create custom override:

```dockerfile
FROM nginx:1.25-alpine

# Copy built web files (after building locally or download)
COPY build/web /usr/share/nginx/html

# Copy nginx config
COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]
```

Or use the provided Dockerfile in repo - it builds Flutter inside Docker!

---

## ✅ TROUBLESHOOTING

### Build Fails
- Check GitHub Actions: https://github.com/softwareprosdev/flutterwebapplication/actions
- Common fix: Update Flutter version in Dockerfile

### Port 3000 Not Working
- Our Dockerfile now exposes both 3000 and 8080 ✅

### SSL Not Working
- Domain must fully propagate first (~2 min)
- Check Cloudflare: Use DNS Only (gray cloud)

### 502 Bad Gateway
- Build still running - check deploy logs
- Wait for "Deployed successfully" in logs

### Static Files Not Loading
- Check: /usr/share/nginx/html has files
- Our nginx config has SPA fallback ✅

---

## 📊 EXPECTED OUTPUT

After successful deployment:
- App URL: https://cal.zerodayinstitute.com
- Health: https://cal.zerodayinstitute.com/health
- Returns: {"status":"ok","timestamp":"..."}

---

## 🎯 REDEPLOY COMMAND

For future updates:

```bash
# Push to GitHub → Auto-deploys
git add .
git commit -m "Update: description"
git push origin main
```

Or trigger manually in Coolify dashboard.

---

## 📞 GETTING HELP

1. Check Coolify logs: App → Deployment → View logs
2. Check GitHub Actions: Repository → Actions tab
3. Cloudflare: Ensure DNS Only (gray cloud)