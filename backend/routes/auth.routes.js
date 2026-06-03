import express from 'express';
import { 
  login, 
  register, 
  updateAdditionalInfo, 
  getProfile,
  updateProfile,
  deleteProfile 
} from '../controllers/auth.controller.js';
import { authenticateToken } from '../middleware/auth.middleware.js';

const router = express.Router();

router.post('/register', register);
router.post('/login', login);
router.put('/additional-info', authenticateToken, updateAdditionalInfo);
router.get('/profile', authenticateToken, getProfile);
router.put('/profile', authenticateToken, updateProfile);
router.delete('/profile', authenticateToken, deleteProfile);

export default router;

