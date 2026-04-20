const express = require('express');
const cors = require('cors');
const fetch = (...args) => import('node-fetch').then(({default: fetch}) => fetch(...args));

const app = express();
const PORT = process.env.PORT || 3000;

const FIRECRAWL_API_KEY = process.env.FIRECRAWL_API_KEY;

app.use(cors());
app.use(express.json());

app.get('/api/miners', async (req, res) => {
  try {
    const miners = [
      {
        name: 'Antminer S21 Pro',
        hash: '335 TH/s',
        power: '5340W',
        price: 3299,
        profit: 12.45,
        minerUrl: 'https://www.asicminervalue.com/miners/bitmain/antminer-s21-pro-335th'
      },
      {
        name: 'Antminer S23 Hydro',
        hash: '1160 TH/s',
        power: '17600W',
        price: 8999,
        profit: 48.92,
        minerUrl: 'https://www.asicminervalue.com/miners/bitmain/antminer-s23-hydro-1160th'
      },
      {
        name: 'Whatsminer M63S',
        hash: '386 TH/s',
        power: '7155W',
        price: 2850,
        profit: 14.21,
        minerUrl: 'https://www.asicminervalue.com/miners/microbt/whatsminer-m63s-386th'
      },
      {
        name: 'Whatsminer M66S',
        hash: '456 TH/s',
        power: '8520W',
        price: 3200,
        profit: 16.88,
        minerUrl: 'https://www.asicminervalue.com/miners/microbt/whatsminer-m66s-456th'
      },
      {
        name: 'AvalonMiner A1466',
        hash: '170 TH/s',
        power: '3300W',
        price: 2099,
        profit: 6.34,
        minerUrl: 'https://www.asicminervalue.com/miners/canaan/avalonminer-a1466-170th'
      },
      {
        name: 'Goldshell KD6',
        hash: '26.3 TH/s',
        power: '2630W',
        price: 1250,
        profit: 0.89,
        minerUrl: 'https://www.asicminervalue.com/miners/goldshell/kd6-26th'
      },
      {
        name: 'iBeLink BM-K3',
        hash: '9.4 TH/s',
        power: '3400W',
        price: 3499,
        profit: 0.32,
        minerUrl: 'https://www.asicminervalue.com/miners/ibelink/bm-k3'
      },
      {
        name: 'Antminer T21',
        hash: '360 TH/s',
        power: '7180W',
        price: 2499,
        profit: 13.45,
        minerUrl: 'https://www.asicminervalue.com/miners/bitmain/antminer-t21-360th'
      }
    ];
    
    res.json({ success: true, miners });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

app.post('/api/scrape', async (req, res) => {
  const { url } = req.body;
  
  if (!url) {
    return res.status(400).json({ success: false, error: 'URL is required' });
  }

  if (!FIRECRAWL_API_KEY) {
    return res.status(500).json({ success: false, error: 'Firecrawl API key not configured' });
  }

  try {
    const response = await fetch('https://api.firecrawl.dev/v2/scrape', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${FIRECRAWL_API_KEY}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        url: url,
        formats: ['markdown', 'html']
      })
    });

    const data = await response.json();
    res.json({ success: true, data });
  } catch (error) {
    console.error('Scrape error:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
