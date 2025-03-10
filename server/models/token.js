const { Schema, model } = require('mongoose');

const tokenSchema = new Schema({
    userId: {
        type: Schema.Types.ObjectId,
        required: true,
        ref: 'User'
    },
    refreshToken: { type: String, required: true },
    accessToken: { type: String, required: true },
    createdAt: { type: Date, default: Date.now, expires: 60 * 8640 }
});

exports.Token = model('Token', tokenSchema);