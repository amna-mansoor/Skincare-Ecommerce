import express from 'express';
import { 
  addToFavorites, 
  getFavorites, 
  removeFromFavorites 
} from '../controllers/favorite.controller.js';
import { authenticateToken } from '../middleware/auth.middleware.js';

const router = express.Router();

router.post('/add', authenticateToken, addToFavorites);
router.get('/', authenticateToken, getFavorites);
router.delete('/:productId', authenticateToken, removeFromFavorites);

export default router; 